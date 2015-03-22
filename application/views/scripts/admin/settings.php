<h2><?php echo __('Settings'); ?></h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo $result['action_url']; ?>" method="post">        
        <table>                     
            <tr>
                <td class="span3"><?php echo __('Language'); ?>:</td>
                <td>
                    <select name="lang">
                        <?php foreach ($result['languages'] as $lang): ?>
                        <option value="<?php echo $lang->lang; ?>" <?php if($settings['lang']==$lang->lang) echo "selected"; ?>><?php echo i18n($lang->i18n, $lang->title); ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="span3"><?php echo __('Admin menu'); ?>:</td>
                <td>
                    <select name="admin_menu">
                        <?php foreach ($result['menus'] as $menu): ?>
                        <option value="<?php echo $menu->id; ?>" <?php if($settings['admin_menu']==$menu->id) echo "selected"; ?>><?php echo i18n($menu->i18n, $menu->title); ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>                    
            </tr>
            <tr>
                <td class="span2" colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo __('Save'); ?>" /></td>
            </tr>
        </table>          
    </form>
<div>