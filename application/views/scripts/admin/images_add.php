<h2><?php echo $action; ?> image</h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo URL::base(true); ?>admin/images/addedit?id=<?php echo $image['id']; ?>" method="post" enctype="multipart/form-data" >
        <input type="hidden" value="<?php echo $image['current']; ?>" />
        <table>
            <tr>
                <td class="span1"></td>
                <td><div class="error errors">
                        <?php
                            foreach ($errors as $err)
                            {
                                echo '<div>' . $err . '</div>';
                            }    
                        ?>
                    </div></td>
            </tr>                    
            <tr>
                <td class="span1">Title:</td>
                <td><input type="text" name="title" value="<?php echo $image['title']; ?>" /></td>
            </tr>
            <tr>
                <td class="span1">File:</td>
                <td><input type="file" name="file" value="<?php echo $image['file']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span1" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span1"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $action; ?> image" /></td>
            </tr>
        </table>          
    </form>
<div>