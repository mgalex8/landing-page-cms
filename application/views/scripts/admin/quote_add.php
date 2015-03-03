<h2><?php echo $action; ?> quote</h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo URL::base(true); ?>admin/quotes/addedit?id=<?php echo $quote['id']; ?>" method="post" enctype="multipart/form-data" >
        <input type="hidden" value="<?php echo $quote['current']; ?>" />
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
                <td class="span1">Author:</td>
                <td><input type="text" name="author" value="<?php echo $quote['author']; ?>" /></td>
            </tr>
            <tr>
                <td class="span1">Title:</td>
                <td><textarea name="text"><?php echo $quote['text']; ?></textarea></td>
            </tr>            
            <tr>
                <td class="span1" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span1"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $action; ?> quote" /></td>
            </tr>
        </table>          
    </form>
<div>